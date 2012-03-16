require 'rake/clean'

CC  = 'clang'
CXX = 'clang++'
LD  = CC

PRODUCTS = {
# executable                    => source file with the main method
  'example_main'                => 'examples/example_main.m',
  'default_description_example' => 'examples/default_description_example.m',
  'readme-example'              => 'examples/example_for_readme.m'
}

CFLAGS = [
  '-DDEBUG',
  '-DDEBUGPRINT_ALL',
  '-std=c99',
  '-fblocks',
  '-fobjc-arc',
  '-IPrettyPrint/',
  '-Iexamples/',
].join(' ')

LIBS = [
  '-framework Foundation'
].join(' ')

OBJC_SOURCES = FileList['examples/*.m', 'NSContainers+PrettyPrint/*.m']
O_FILES = OBJC_SOURCES.ext('.o')

rule '.o' => ['.m'] do |t|
  sh "#{CC} #{t.source} #{CFLAGS} -c -o #{t.name}"
end

OBJC_SOURCES.each do |src|
  file src.ext(".o") => src
end

PRODUCTS.each do |product, source|
  # remove the object files for other products to avoid "multiple _main method" errors
  object_files = O_FILES - (PRODUCTS.values - [source]).map{|f|f.ext('.o')}
  desc 'Build executable for \''+product+'\''
  file product => object_files do |t|
    sh "#{LD} #{LIBS} #{object_files} -o #{t.name}"
  end
end

desc 'FIRE EVERYTHING!!'
task :all => PRODUCTS.keys

CLEAN.include("**/*.o")
CLOBBER.include(PRODUCTS.keys)

task :default => 'all'
