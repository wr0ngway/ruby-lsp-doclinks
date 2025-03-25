# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ruby_lsp/doclinks"

require "minitest/autorun"

require "sorbet-runtime"
require "ruby_lsp/test_helper"
