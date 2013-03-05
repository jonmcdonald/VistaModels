#!/public/Integration/perl/bin/perl

# "Namespace[ ]+eval" -> "namespace eval"
# "Class name {" -> "class name {"
# "[Cc]lass name { [\n ]+ Inherit" class name { \n inherit
# "[Pp]ublic [Mm]ethod name {" "public method name {"
# "Method name {" "method { name"
# "[Pp]ublic [Mm]onstructor name {" "public constructor name {"
# "Constructor name {" "constructor name {"
# "Destructor name {" "destructor {"
# "[Pp]ublic [Pp]roc name {" "public proc name {"
# "[Pp]roc name {" "proc name {"
# "[Pp]rivate [Pp]roc name {" "private proc name {"

#use File::Basename;
#use File::Copy;

my $source_file = $ARGV[0];

if(!$source_file){
  print "convert: Insufficient argument\n";
  print "Usage: perl convert.pl source_file\n";
  exit 1;
}

open(SOURCE,"$source_file");

while(<SOURCE>){

  s/(^\s*)Namespace +eval +/$1namespace eval /;
  s/(^\s*)Class +(\S+) +\{/$1::itcl::class $2 \{/;
  s/(^\s*)class +(\S+) +\{/$1::itcl::class $2 \{/;
  s/(^\s*)[Pp]ublic +[Mm]ethod +(\S+) +\{/$1public metod $2 \{/;
  s/(^\s*)[Mm]ethod +(\S+) +\{/$1metod $2 \{/;
  s/(^\s*)[Pp]ublic +[Pp]roc +(\S+) +\{/$1public proc $2 \{/;
  s/(^\s*)[Pp]roc +(\S+) +\{/$1proc $2 \{/;

  print $_;
}

close(SOURCE);

exit 0;
