# frozen_string_literal: true

require 'pact/v2'
require 'pact/v2/rspec'
require 'webmock/rspec'
# for pact/v2 with non rail apps
require 'active_support/core_ext/object/deep_dup'
require 'active_support/core_ext/object/blank'
# https://guides.rubyonrails.org/active_support_core_extensions.html#stand-alone-active-support
