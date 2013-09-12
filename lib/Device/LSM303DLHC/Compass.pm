package Device::LSM303DLHC::Compass;

# PODNAME: Device::LSM303DLHC::Compass
# ABSTRACT: I2C interface to Compass on the LSM303DLHC 3 axis magnetometer(compass) and accelerometer using Device::SMBus
#
# This file is part of Device-LSM303DLHC
#
# This software is copyright (c) 2013 by Shantanu Bhadoria.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
our $VERSION = '0.004'; # VERSION

use 5.010;
use Moose;
use POSIX;

extends 'Device::SMBus';

has '+I2CDeviceAddress' => (
    is      => 'ro',
    default => 0x1e,
);

# Registers for the Magnetometer
use constant { MR_REG_M => 0x02, };

# X, Y and Z Axis magnetic Field Data value in 2's complement
use constant {
    OUT_X_H_M => 0x03,
    OUT_X_L_M => 0x04,

    OUT_Y_H_M => 0x07,
    OUT_Y_L_M => 0x08,

    OUT_Z_H_M => 0x05,
    OUT_Z_L_M => 0x06,
};

has magnetometerMaxVector => (
    is      => 'rw',
    default => sub {
        return (
            x => 0,
            y => 0,
            z => 0,
        );
    },
);

has magnetometerMinVector => (
    is      => 'rw',
    default => sub {
        return (
            x => 0,
            y => 0,
            z => 0,
        );
    },
);


sub enable {
    my ($self) = @_;
    $self->writeByteData( MR_REG_M, 0x00 );
}


sub getRawReading {
    my ($self) = @_;

    return (
        x => $self->_typecast_int_to_int16(
            ( $self->readByteData(OUT_X_H_M) << 8 ) |
              $self->readByteData(OUT_X_L_M)
        ),
        y => $self->_typecast_int_to_int16(
            ( $self->readByteData(OUT_Y_H_M) << 8 ) |
              $self->readByteData(OUT_Y_L_M)
        ),
        z => $self->_typecast_int_to_int16(
            ( $self->readByteData(OUT_Z_H_M) << 8 ) |
              $self->readByteData(OUT_Z_L_M)
        ),
    );
}


sub getReading {
    my ($self) = @_;
}

sub _typecast_int_to_int16 {
    return unpack 's' => pack 'S' => $_[1];
}

1;

__END__

=pod

=head1 NAME

Device::LSM303DLHC::Compass - I2C interface to Compass on the LSM303DLHC 3 axis magnetometer(compass) and accelerometer using Device::SMBus

=head1 VERSION

version 0.004

=head1 METHODS

=head2 enable 

    $self->enable()

Initializes the device, Call this before you start using the device. This function sets up the appropriate default registers.
The Device will not work properly unless you call this function

=head2 getRawReading

    $self->getRawReading()

Return raw readings from accelerometer registers

=head2 getReading

    $self->getReading()

Return proper calculated readings from the magnetometer

=head1 AUTHOR

Shantanu Bhadoria <shantanu at cpan dott org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Shantanu Bhadoria.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
