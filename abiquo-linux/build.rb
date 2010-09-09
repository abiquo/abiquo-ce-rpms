#!/usr/bin/env ruby
require 'rubygems'
require 'fileutils'
require 'term/ansicolor'
require 'logger'

$stdout.sync = true
Log = File.open 'build.log', 'w'

class String
  include Term::ANSIColor
end

BASEDIR = Dir.pwd

package_dirs = []
Dir['*'].each do |dir|
  package_dirs << dir if (File.exist? "#{dir}/build.sh" and File.directory?(dir))
end

count = 0
package_dirs.each do |dir|
  count += 1
  print "Building #{dir} [#{count}/#{package_dirs.size}]... "
  Dir.chdir dir
  Log.puts "**************************"
  Log.puts "BUILDING #{dir}"
  Log.puts "**************************"
  output = `sh build.sh 2>&1`
  if (($?.exitstatus == 0) and (not Dir["rpms/*.rpm"].empty?))
    puts "Ok".green.bold
  else
    puts "Failed".bold.red
  end
   
  Log.puts output
  Dir.chdir BASEDIR
end

Log.close
