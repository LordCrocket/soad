package Event;
use Moose;


extends 'Information';
has 'participants' => (is => 'ro', isa => 'ArrayRef[Citizen]',required => '0');
 1;
