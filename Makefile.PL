use ExtUtils::MakeMaker;
WriteMakefile( NAME         => "Test::CGI::Untaint",
               VERSION_FROM => "lib/Test/CGI/Untaint.pm",
               PREREQ_PM    => { Test::Builder::Tester => 0.09,
				 CGI::Untaint => 0.82,
			       },
);

