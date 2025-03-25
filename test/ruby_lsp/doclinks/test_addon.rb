# frozen_string_literal: true

require "test_helper"
require "ruby_lsp/doclinks/addon"

class RubyLsp::Doclinks::AddonTest < Minitest::Test
  def test_my_addon_works
    assert_equal "Doclinks", RubyLsp::DocLinks::Addon.new.name

    # TODO: figure out how to test this
    #
    # source =  <<~RUBY
    #   # Some test code that allows you to trigger your add-on's contribution
    #   class Foo
    #     def something
    #     end
    #   end
    # RUBY

    # with_server(source) do |server, uri|
    #   # Tell the server to execute the definition request
    #   server.process_message(
    #     id: 1,
    #     method: "textDocument/definition",
    #     params: {
    #       textDocument: {
    #         uri: uri.to_s,
    #       },
    #       position: {
    #         line: 3,
    #         character: 5
    #       }
    #     }
    #   )

    #   # Pop the server's response to the definition request
    #   result = server.pop_response.response
    #   # Assert that the response includes your add-on's contribution
    #   assert_equal(123, result.response.location)
    # end
  end
end
