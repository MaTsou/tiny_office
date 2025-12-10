# frozen_string_literal: true

require "bundler/gem_tasks"
task default: %i[]

file 'minify_js' do |t|
  sh "minify -b -o lib/tiny_office/js/tinyoffice.min.js lib/tiny_office/js/src/*"
end
