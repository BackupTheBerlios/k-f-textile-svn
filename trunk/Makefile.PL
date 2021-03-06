use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Kwiki::Formatter::Textile',
    'VERSION'	=> '1.0',
    PREREQ_PM   => {
        'Kwiki' => '0',
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Textile.pm', # retrieve abstract from module
       AUTHOR     => 'Jochen Lillich <jochen@lillich.info>') : ()),
);
