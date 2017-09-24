functions {
    real rel_potential(real r, real G, real Mbh) {
        /*
            Computes the relative potential. In this case, just
            negative of the potential.

            Parameters
            ----------
            r : Galactocentric radius [milliparsec]
            Mbh : Mass of Sgr A* [Msun]
        */
        return (G * Mbh) / r;
    }

    real rv_to_E(real r, real v, real G, real Mbh) {
        /*
            Convert a Galactocentric distance and velocity into
            a relative energy.

            Parameters
            ----------
            r : Galactocentric radius [milliparsec]
            v : Galactocentric velocity [milliparsec^2 / yr^2]
        */
        return -0.5*v*v + rel_potential(r, G, Mbh);
    }

    real df_lpdf(real E, real L, real G, real Mbh, real gam, real beta) {
        /*
            Compute the value of the log-distribution function
            at the specified relative energy.

            Parameters
            ----------
            E : Relative energy [milliparsec^2 / yr^2]
            L : angular momentum [milliparsec^2 / yr]
            Mbh : Mass of Sgr A* [Msun]
            gam : Density profile power-law index
            beta : Anisotropy parameter (1 = radial, -inf = tangential)
        */
        real num;
        real den;
        real gams;

        if (E <= 0) {
            return negative_infinity();
        }

        num = -2*beta*log(L) + (gam-beta-1.5) * log(E) + beta*log(2);
        den = 1.5*log(2*pi()) + (gam-2*beta) * log(G*Mbh);
        gams = lgamma(gam - 2*beta + 1) - lgamma(gam - beta - 0.5);

        return num - den + gams;
    }
}

data {
    int<lower=1> N; // total number of tracers

    // Some fake data...
    // real r[N];
    // real v[N];
    // real r_err[N];
    // real v_err[N];
    real true_r[N];
    real true_v[N];
}

transformed data {
    real G = 4.498502151575286e-06; // millipc^3 / Msun / yr^2

    // Fixed parameters (for now)
    real beta = 0.;
    real gamma = 2.5;
    // real Mbh = 4e6;
}

parameters {
    real<lower=0> Mbh;

    // real<lower=0> true_r[N];
    // real<lower=0> true_v[N];

    // real<lower=0.01, upper=5> gamma;
    // real<upper=1> beta;
}

transformed parameters {
    real<lower=0> E[N];

    // Compute E, L for DF / likelihood evaluation
    for(n in 1: N) {
        E[n] = rv_to_E(true_r[n], true_v[n], G, Mbh);
    }
}

model {
    for(n in 1: N) {
        // Gaussian errors
        // true_r[n] ~ normal(r[n], r_err[n]) T[0,];
        // true_v[n] ~ normal(v[n], v_err[n]) T[0,];

        target += df_lpdf(E[n] | 1., G, Mbh, gamma, beta);
        target += 2*log(true_r[n]) + 2*log(true_v[n]);
        target += 2*log(4*pi());
    }
}
