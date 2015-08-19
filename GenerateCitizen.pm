package GenerateCitizen;
use Citizen;
use Moose;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

extends 'GameModule';

my $logger = Log::Log4perl->get_logger('generatecitizen');

has 'number_of_citizens' => (is => 'ro', isa => 'Attribute', required => '1');

sub _generate_citizens {
	(my $self, my $number) = @_;	

	my $occupations = find_type_constraint('Occupation')->{values};

	my @citizens = ();	
	for(1..$number) {
		push(@citizens,Citizen->new(
			name => scalar(<DATA>),
			age => $self->_inclusive_int_rand(45) + 20,
			occupation => @$occupations[int(rand(scalar @$occupations))],
			loyalty => $self->_generate_attribute(),
			financial_status => $self->_generate_attribute(),
			social_life => $self->_generate_attribute()
			)
		);
	}

	return \@ citizens;
}

sub _generate_attribute {
	(my $self) = @_;
	my $attribute_span = Citizen->attribute_max - Citizen->attribute_min;
	return $self->_inclusive_int_rand($attribute_span) + Citizen->attribute_min;
}


sub _inclusive_int_rand {
	(my $self, my $range) = @_;
	return int(rand($range + 1));
}

override 'setup' => sub {
	(my $self, my $game_state) = @_;

	$logger->debug("Generating citizens");

	my $citizens = $self->_generate_citizens($self->number_of_citizens); 
	foreach my $citizen (@{$citizens}) {
		$game_state->add_citizen($citizen);
	}
	
};

__PACKAGE__->meta->make_immutable;
1;

__DATA__
Hannelore Sabine  
Domenic Wilborn  
Kathie Lenard  
Norris Kimbell  
Donella Amar  
Gale Berndt  
Lenore Bittle  
Teodoro Boerner  
Margaret Sones  
Colby Malbrough  
Valencia Springs  
Carey Ding  
Delsie Baginski  
Shelton Sparks  
Kristeen Collingwood  
Ernest Marchal  
Ouida Serrato  
Dominic Thomasson  
Colette Singleterry  
Orval Siegfried  
Avril Sokolowski  
Boris Crete  
Londa Pautz  
Jonas Provenzano  
Doretha Windom  
Giuseppe Duryea  
Ruby Sturtz  
Cristobal Corr  
Leona Huddleston  
Nickolas Blackshire  
Evette Ruel  
Elroy Radford  
Sylvie Achenbach  
Daniel Toole  
Georgianna Claeys  
Damian Hathcock  
Myrtice Figueras  
Rudy Sanderson  
Tyisha Blunk  
Glen Hodgkinson  
Sharyl Dino  
Ben Bolton  
Jannet Mayon  
Jerald Spoor  
Nancie Bourne  
Zachery Walmsley  
Lala Sturm  
Kristofer Erikson  
Serina Eager  
Cliff Hardt  
Emily Aldrete  
Philip Pieper  
Marry Rosenberg  
Mariano Schilke  
Lise Sink  
Rocco Kilburn  
Reginia Palomino  
Kermit Galiano  
Domitila Calo  
Robert Keplinger  
Danielle Valtierra  
Laurence Reindl  
Lacie Astorga  
Virgil Demay  
Millicent Swing  
Branden Quijada  
Tawna Pemberton  
Alonso Haugland  
Heather Marra  
Lynwood Kahn  
Shenika Dumbleton  
Floyd Ansari  
Tobi Alvelo  
Jay Jervis  
Reiko Dunnam  
Chuck Zick  
Cari Park  
Alonzo Pannone  
Alethea Gaiter  
Jason Nunley  
Elodia Gregory  
Kareem Carranco  
Kandice Vidal  
Charles Bilbrey  
Ozie Morell  
Wilbert Rios  
Dorotha Monterroso  
Jeremiah Theobald  
Alla Blankinship  
Rodrick Sustaita  
Catherin Mackley  
Shad Sheley  
Carolyn Godbee  
Lucio Finnegan  
Anjelica Necessary  
Dana Hilt  
Veta Fresquez  
Duane Galvez  
Dixie Cola  
Elbert Lepore  
