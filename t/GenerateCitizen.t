use strict; 
use warnings;
use Test::More tests => 1;
use 5.18.0;


use GenerateCitizen;

my $seed = srand();
my $citizensFirstRound = GenerateCitizen::generate_citizens(1);
my $citizen1 = $citizensFirstRound->[0];

srand($seed);
my $citizensSecondRound = GenerateCitizen::generate_citizens(1);
my $citizen2 = $citizensSecondRound->[0];


subtest 'Same seed generation' => sub {
	plan tests => 6;

	is($citizen1->name,$citizen2->name, "Check same name");
	is($citizen1->age,$citizen2->age, "Check same age");
	is($citizen1->occupation,$citizen2->occupation, "Check same occupation");
	is($citizen1->loyalty,$citizen2->loyalty, "Check same loyalty");
	is($citizen1->financial_status,$citizen2->financial_status, "Check same financial status");
	is($citizen1->social_life,$citizen2->social_life, "Check same social life");

};

