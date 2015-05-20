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

		my $attribute_span = Citizen->attribute_max - Citizen->attribute_min;

		my $name = scalar(<$fh>);
		my $age = inclusive_int_rand(45) + 20;
		my $loyalty = inclusive_int_rand($attribute_span) + Citizen->attribute_min;
		my $financial_status = inclusive_int_rand($attribute_span) + Citizen->attribute_min;
		my $social_life = inclusive_int_rand($attribute_span) + Citizen->attribute_min;
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
