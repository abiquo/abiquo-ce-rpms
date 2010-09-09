#!/usr/bin/env ruby
require 'fileutils'

REPO_PATH='repo/'

package_dirs = []
Dir['*'].each do |dir|
  package_dirs << dir + '/rpms' if File.directory? "#{dir}/rpms"
end

package_dirs.each do |dir|
  Dir["#{dir}/*.rpm"].each do |pkg|
    FileUtils.copy pkg, REPO_PATH
  end
  Dir["#{dir}/SRPMS/*.rpm"].each do |pkg|
    FileUtils.copy pkg, "#{REPO_PATH}/SRPMS"
  end
end

`repomanage --old #{REPO_PATH}|xargs rm > /dev/null 2>&1`
`createrepo -d #{REPO_PATH}`
