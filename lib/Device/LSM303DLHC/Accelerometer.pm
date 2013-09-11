package Device::LSM303DLHC::Accelerometer;

# PODNAME: Device::LSM303DLHC::Accelerometer
# ABSTRACT: I2C interface to Accelerometer on the LSM303DLHC 3 axis magnetometer(compass) and accelerometer using Device::SMBus
#
# This file is part of Device-LSM303DLHC
#
# This software is copyright (c) 2013 by Shantanu Bhadoria.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
our $VERSION = '0.001'; # VERSION

use 5.010;
use Moose;
use POSIX;

extends 'Device::SMBus';

has '+I2CDeviceAddress' => (
    is      => 'ro',
    default => 0x19,
);

# Registers for the Accelerometer
use constant {
    CTRL_REG1_A => 0x20,
    CTRL_REG4_A => 0x23,
};

# X, Y and Z Axis magnetic Field Data value in 2's complement
use constant {
    OUT_X_H_A => 0x29,
    OUT_X_L_A => 0x28,

    OUT_Y_H_A => 0x2b,
    OUT_Y_L_A => 0x2a,

    OUT_Z_H_A => 0x2d,
    OUT_Z_L_A => 0x2c,
};

use integer
  ; # Use arithmetic right shift instead of unsigned binary right shift with >> 4


sub enable {
    my ($self) = @_;
    $self->writeByteData( CTRL_REG1_A, 0b01010111 );
    $self->writeByteData( CTRL_REG4_A, 0b00101000 );
}


sub getRawReading {
    my ($self) = @_;

    return (
        x => (
            $self->_typecast_int_to_int16(
                ( $self->readByteData(OUT_X_H_A) << 8 ) |
                  $self->readByteData(OUT_X_L_A)
            )
          ) >> 4,
        y => (
            $self->_typecast_int_to_int16(
                ( $self->readByteData(OUT_Y_H_A) << 8 ) |
                  $self->readByteData(OUT_Y_L_A)
            )
          ) >> 4,
        z => (
            $self->_typecast_int_to_int16(
                ( $self->readByteData(OUT_Z_H_A) << 8 ) |
                  $self->readByteData(OUT_Z_L_A)
            )
        ) >> 4,
    );
}

sub _typecast_int_to_int16 {
    return unpack 's' => pack 'S' => $_[1];
}

sub calibrate {
    my ($self) = @_;

}

1;

__END__

=pod

=head1 NAME

Device::LSM303DLHC::Accelerometer - I2C interface to Accelerometer on the LSM303DLHC 3 axis magnetometer(compass) and accelerometer using Device::SMBus

=head1 VERSION

version 0.001

=head1 METHODS

=head2 enable 

    $self->enable()

Initializes the device, Call this before you start using the device. This function sets up the appropriate default registers.
The Device will not work properly unless you call this function

=head2 getRawReading

    $self->getRawReading()

Return raw readings from accelerometer registers

=head1 AUTHOR

Shantanu Bhadoria <shantanu at cpan dott org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Shantanu Bhadoria.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
