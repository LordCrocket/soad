package GenerateCitizen;
use Citizen;

my $names_file = 'names';
use Moose::Util::TypeConstraints;


sub generate_citizens {
	(my $number) = @_;	

	open(my $fh, '<:encoding(UTF-8)', $names_file)
	  or die "Could not open file '$names_file' $!";

	my $occupations = find_type_constraint('Occupation')->{values};

	my @citizens = ();	
	for(1..$number) {
		my $name = scalar(<$fh>);
		my $age = int(rand(45)) + 20;
		my $loyalty = int(rand(10));
		my $financial_status = int(rand(10));
		my $social_life = int(rand(10));
		my $occupation = @$occupations[int(rand(scalar @$occupations))];
		push(@citizens,Citizen->new(
		name => $name,
		age => $age,
		occupation => $occupation,
		loyalty => $loyalty,
		financial_status => $financial_status,
		social_life => $social_life));
	}

	return \@ citizens;
}


sub inclusive_int_rand {
	(my $range) = @_;
	return int(rand($range +1);
}
