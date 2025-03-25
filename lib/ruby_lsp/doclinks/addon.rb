# frozen_string_literal: true

require "ruby_lsp/addon"
require "ruby_lsp/requests/support/common"

module RubyLsp
  module DocLinks
    class Addon < ::RubyLsp::Addon
      def initialize
        super

        @settings = {
          rubydoc_url: "https://www.rubydoc.info/gems/%{gem_name}/%{version}/%{constant}#%{method}",
          yard_url: "http://localhost:8808/docs/%{gem_name}/%{version}/%{constant}#%{method}",
          custom_url: "Add a custom Url for %{gem_name} %{version} %{constant} %{method}",
          doc_source: :rubydoc # :rubydoc, :yard or :custom
        }
      end

      def activate(global_state, message_queue)
        @global_state = global_state
        @message_queue = message_queue
        $stderr.puts "Activating '#{name}' LSP addon v#{RubyLsp::Doclinks::VERSION}"

        addon_settings = @global_state.settings_for_addon(name)
        $stderr.puts "#{name} addon settings: #{addon_settings.inspect}"
        @settings.merge!(addon_settings) if addon_settings
      end

      def deactivate
        # No cleanup needed
      end

      def name
        "Doclinks"
      end

      def version
        "0.1.0"
      end

      def create_hover_listener(response_builder, node_context, dispatcher)
        Hover.new(@settings, response_builder, dispatcher)
      end
    end

    class Hover
      include Requests::Support::Common

      def initialize(settings, response_builder, dispatcher)
        @settings = settings
        @response_builder = response_builder


        # Subscribe to various node types
        dispatcher.register(self, :on_constant_read_node_enter)
        dispatcher.register(self, :on_constant_path_node_enter)
        dispatcher.register(self, :on_call_node_enter)
      end

      def on_constant_read_node_enter(node)
        # $stderr.puts "#{name} addon handling on_constant_read_node_enter: #{node.inspect} slice=#{node&.slice&.inspect}"
        constant = node.slice
        handle_constant(constant)
      end

      def on_constant_path_node_enter(node)
        # $stderr.puts "#{name} addon handling on_constant_path_node_enter: #{node.inspect} slice=#{node&.slice&.inspect}"
        # Handle nested constants like Foo::Bar
        constant = node.slice
        handle_constant(constant)
      end

      def on_call_node_enter(node)
        # $stderr.puts "#{name} addon handling on_call_node_enter: #{node.name} receiver_slice=#{node&.receiver&.slice&.inspect}"
        # Handle method calls
        constant = node.receiver&.slice
        method = node.name
        # $stderr.puts "#{name} addon constant=#{constant} method=#{method} node=#{node.inspect}"
        handle_constant(constant, method)
      end

      private

      def handle_constant(constant, method_name = nil)
        # $stderr.puts "#{name} addon handling: #{constant}#{method_name ? "##{method_name}" : ""}"
        return unless constant && !constant.empty?

        # Check if the word is a gem constant
        gem_info = find_gem_for_constant(constant)
        # $stderr.puts "#{name} addon gem_info: #{gem_info.inspect}"
        return unless gem_info

        # Generate documentation link based on configuration
        doc_link = generate_doc_link(gem_info, constant, method_name)
        # $stderr.puts "#{name} addon doc_link: #{doc_link}"
        return unless doc_link

        # $stderr.puts "#{name} addon adding hover response"
        display_name = method_name ? "#{constant}##{method_name}" : constant
        content = "\n[View documentation for #{display_name}](#{doc_link})"
        @response_builder.push(content, category: :documentation)
      end

      def find_gem_for_constant(constant)
        # Try with the full constant path first
        gem_info = find_gem_with_constant(constant)
        return gem_info if gem_info

        # If not found, try with the base constant
        base_constant = constant.split("::").first
        return nil if base_constant.nil? || base_constant.empty?

        find_gem_with_constant(base_constant)
      end

      def find_gem_with_constant(constant_name)
        Gem.loaded_specs.find do |name, spec|
          spec.full_require_paths.any? do |path|
            next if path.nil? || path.empty?

            Dir.glob("#{path}/**/*.rb").any? do |file|
              next if file.nil?

              begin
                content = File.read(file)
                next if content.nil? || content.empty?

                # Look for class/module definitions with the exact constant name
                content.match?(/\b(?:class|module)\s+#{Regexp.escape(constant_name)}\b/)
              rescue => e
                $stderr.puts "Error reading file #{file}: #{e.message}"
                false
              end
            end
          end
        end
      end

      def generate_doc_link(gem_info, constant, method_name = nil)
        return nil if gem_info.nil? || constant.nil? || constant.empty?

        name, spec = gem_info
        return nil if name.nil? || spec.nil?

        source = @settings[:doc_source]
        base_url = @settings["#{source}_url".to_sym]
        return nil if base_url.nil?

        # TODO: figure out to get more than a constant's class method.
        # e.g. an instance method on a local variable
        method_type = method_name ? "-class_method" : ""
        doc_url = base_url % {
          gem_name: name,
          version: spec.version,
          constant: constant.gsub("::", "/"),
          method: "#{method_name}#{method_type}"
        }
        $stderr.puts "#{name} addon doc_url for source=#{source}: #{doc_url}"

        doc_url
      end
    end
  end
end
