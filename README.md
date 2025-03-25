# Ruby::Lsp::Doclinks

An addon for the VsCode RubyLsp extension that provides documentation links in hovers for constants (classes/modules), and their methods

## Installation

Setup VsCode to use the [Ruby-LSP extension](https://marketplace.visualstudio.com/items?itemName=Shopify.ruby-lsp), then install this gem so that Ruby-LSP can find it.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add ruby-lsp-doclinks
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install ruby-lsp-doclinks
```

## Usage

By default, the addon will use rubygems as it's documentation source.  If you hover over a constant, like a classname, it will generate a link to documentation at the bottom of the hover.

If you'd like to use a yard server or something custom, you can customize the documentation url through the Ruby LSP addon settings in settings.json which will look something like:
```json
    "rubyLsp.addonSettings": {
        "Doclinks": {
            // Source can be anything so long as you have a matching "<source>_url" setting
            // Urls for yard and rubydoc are predefined as shown below
            //
            "doc_source": "yard"

            // Optionally customize the url pattern, default formats are
            //
            // "yard_url": "http://localhost:8808/docs/%{gem_name}/%{version}/%{constant}#%{method}"
            // "rubydoc_url": "https://www.rubydoc.info/gems/%{gem_name}/%{version}/%{constant}#%{method}"
            // "custom_url": "Add a custom Url for %{gem_name} %{version} %{constant} %{method}"
        }
    }
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

You can point your project to a path based version of the gem with an entry in your Gemfile like:
```
  gem "ruby-lsp-doclinks", path: "~/myprojects/ruby-lsp-doclinks"
```

Make sure to `Cmd-Shift-P` - `Developer: Reload Window` in VsCode to reload LSP and this plugin in order to see the result of any code changes.  Select the `Ruby LSP` from the dorpdown in the VsCode `Output` panel to see any logs.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wr0ngway/ruby-lsp-doclinks. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/wr0ngway/ruby-lsp-doclinks/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Lsp::Doclinks project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wr0ngway/ruby-lsp-doclinks/blob/main/CODE_OF_CONDUCT.md).
