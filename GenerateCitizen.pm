package GenerateCitizen;
use Citizen;

my $names_file = 'names';
use Moose::Util::TypeConstraints;
use String::Trim;


sub generate_citizens {
	(my $number) = @_;	

	open(my $fh, '<:encoding(UTF-8)', $names_file)
	  or die "Could not open file '$names_file' $!";

	my $occupations = find_type_constraint('Occupation')->{values};

	my @citizens = ();	
	for(1..$number) {
		push(@citizens,Citizen->new(
			name => trim(scalar(<$fh>)),
			age => inclusive_int_rand(45) + 20,
			occupation => @$occupations[int(rand(scalar @$occupations))],
			loyalty => generate_attribute(),
			financial_status => generate_attribute(),
			social_life => generate_attribute()
			)
		);
	}

	return \@ citizens;
}

sub generate_attribute {
	my $attribute_span = Citizen->attribute_max - Citizen->attribute_min;
	return inclusive_int_rand($attribute_span) + Citizen->attribute_min;
}


sub inclusive_int_rand {
	(my $range) = @_;
	return int(rand($range +1));
}
