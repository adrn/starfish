# Third-party
import astropy.units as u
import astropy.coordinates as coord
import numpy as np

__all__ = ['rv_to_3d_isotropic']

def rv_to_3d_isotropic(r, v):
    """Given radii and velocity magnitudes, generate a set of 6D initial
    conditions by assuming isotropy.

    Parameters
    ----------
    r : quantity_like [length]
        Radii.
    v : quantity_like [speed]
        Velocity magnidues.
    """

    phi = np.random.uniform(0, 2*np.pi, size=r.size) * u.radian
    theta = np.arccos(2*np.random.uniform(size=r.size) - 1) * u.radian
    sph = coord.PhysicsSphericalRepresentation(phi=phi, theta=theta, r=r)
    xyz = sph.represent_as(coord.CartesianRepresentation).xyz

    phi = np.random.uniform(0, 2*np.pi, size=r.size) * u.radian
    theta = np.arccos(2*np.random.uniform(size=r.size) - 1) * u.radian
    v_sph = coord.PhysicsSphericalRepresentation(phi=phi, theta=theta,
                                                 r=np.ones_like(v)*u.one)
    v_xyz = v * v_sph.represent_as(coord.CartesianRepresentation).xyz

    return xyz, v_xyz

