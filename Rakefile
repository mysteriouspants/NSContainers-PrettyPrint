require 'rake/clean'

CC = 'clang'
LD = CC

PRODUCTS = [
  'example_main'
]

CFLAGS = [
  '-DDEBUG'
].join(' ')

LIBS = [
  '-framework Foundation'
].join(' ')

OBJC_SOURCES = FileList['*.m']
O_FILES = OBJC_SOURCES.sub(/\.m$/, '.o')

PRODUCTS.each do |product|
  file product => O_FILES do |t|
    sh "#{LD} #{LIBS} #{O_FILES} -o #{t.name}"
  end
end

OBJC_SOURCES.each do |src|
  file src.ext(".o") => src
end

rule '.o' => ['.m'] do |t|
  sh "#{CC} #{t.source} #{CFLAGS} -c -o #{t.name}"
end

CLEAN.include("**/*.o")
PRODUCTS.each {|prod|CLOBBER.include(prod)}

task :default => 'example_main'
