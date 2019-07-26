
. import delimited "T:\Tax Burden\Data Collection\PUMS\PUMS RAW DATA 2017.csv"
(233 vars, 158764 obs)

. browse

. svyset [iw=perwgt], sdr(pwgtp1-pwgtp80) vce(sdr)
variable pwgtp1 not found
varlist required
r(100);

. svyset [iw=wgtp], sdr(wgtp1-wgtp80) vce(sdr)

      iweight: wgtp
          VCE: sdr
          MSE: off
    sdrweight: wgtp1 wgtp2 wgtp3 wgtp4 wgtp5 wgtp6 wgtp7 wgtp8 wgtp9 wgtp10 wgtp11 wgtp12 wgtp13 wgtp14 wgtp15 wgtp16 wgtp17 wgtp18 wgtp19 wgtp20 wgtp21 wgtp22
               wgtp23 wgtp24 wgtp25 wgtp26 wgtp27 wgtp28 wgtp29 wgtp30 wgtp31 wgtp32 wgtp33 wgtp34 wgtp35 wgtp36 wgtp37 wgtp38 wgtp39 wgtp40 wgtp41 wgtp42 wgtp43
               wgtp44 wgtp45 wgtp46 wgtp47 wgtp48 wgtp49 wgtp50 wgtp51 wgtp52 wgtp53 wgtp54 wgtp55 wgtp56 wgtp57 wgtp58 wgtp59 wgtp60 wgtp61 wgtp62 wgtp63 wgtp64
               wgtp65 wgtp66 wgtp67 wgtp68 wgtp69 wgtp70 wgtp71 wgtp72 wgtp73 wgtp74 wgtp75 wgtp76 wgtp77 wgtp78 wgtp79 wgtp80
  Single unit: missing
     Strata 1: <one>
         SU 1: <observations>
        FPC 1: <zero>

. mean fincp

Mean estimation                   Number of obs   =     89,031

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
       fincp |   80977.94   281.9731      80425.28    81530.61
--------------------------------------------------------------

. mean svy fincp
variable svy not found
r(111);

. svy: mean fincp
(running mean on estimation sample)

SDR replications (80)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..............................

Survey: Mean estimation           Number of obs   =    102,982
                                  Population size =  1,685,364
                                  Replications    =         80

--------------------------------------------------------------
             |                 SDR
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
       fincp |    77870.8   242.5482      77395.42    78346.19
--------------------------------------------------------------

. clear

. import delimited "C:\Users\SITGuest\Desktop\psam_h47 (10).csv"
(233 vars, 158764 obs)

. svyset [iw=wgtp], sdr(wgtp1-wgtp80) vce(sdr)

      iweight: wgtp
          VCE: sdr
          MSE: off
    sdrweight: wgtp1 wgtp2 wgtp3 wgtp4 wgtp5 wgtp6 wgtp7 wgtp8 wgtp9 wgtp10 wgtp11 wgtp12 wgtp13 wgtp14 wgtp15 wgtp16 wgtp17 wgtp18 wgtp19 wgtp20 wgtp21 wgtp22
               wgtp23 wgtp24 wgtp25 wgtp26 wgtp27 wgtp28 wgtp29 wgtp30 wgtp31 wgtp32 wgtp33 wgtp34 wgtp35 wgtp36 wgtp37 wgtp38 wgtp39 wgtp40 wgtp41 wgtp42 wgtp43
               wgtp44 wgtp45 wgtp46 wgtp47 wgtp48 wgtp49 wgtp50 wgtp51 wgtp52 wgtp53 wgtp54 wgtp55 wgtp56 wgtp57 wgtp58 wgtp59 wgtp60 wgtp61 wgtp62 wgtp63 wgtp64
               wgtp65 wgtp66 wgtp67 wgtp68 wgtp69 wgtp70 wgtp71 wgtp72 wgtp73 wgtp74 wgtp75 wgtp76 wgtp77 wgtp78 wgtp79 wgtp80
  Single unit: missing
     Strata 1: <one>
         SU 1: <observations>
        FPC 1: <zero>

. svy: mean fincp
(running mean on estimation sample)

SDR replications (80)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..............................

Survey: Mean estimation           Number of obs   =    102,982
                                  Population size =  1,685,364
                                  Replications    =         80

--------------------------------------------------------------
             |                 SDR
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
       fincp |    77870.8   242.5482      77395.42    78346.19
--------------------------------------------------------------

. clear

. import delimited "C:\Users\SITGuest\Desktop\psam_h47 (10).csv"
(233 vars, 158764 obs)

. svyset [pw=wgtp], sdr(wgtp1 - wgtp80) vce(sdr) mse

      pweight: wgtp
          VCE: sdr
          MSE: on
    sdrweight: wgtp1 wgtp2 wgtp3 wgtp4 wgtp5 wgtp6 wgtp7 wgtp8 wgtp9 wgtp10 wgtp11 wgtp12 wgtp13 wgtp14 wgtp15 wgtp16 wgtp17 wgtp18 wgtp19 wgtp20 wgtp21 wgtp22
               wgtp23 wgtp24 wgtp25 wgtp26 wgtp27 wgtp28 wgtp29 wgtp30 wgtp31 wgtp32 wgtp33 wgtp34 wgtp35 wgtp36 wgtp37 wgtp38 wgtp39 wgtp40 wgtp41 wgtp42 wgtp43
               wgtp44 wgtp45 wgtp46 wgtp47 wgtp48 wgtp49 wgtp50 wgtp51 wgtp52 wgtp53 wgtp54 wgtp55 wgtp56 wgtp57 wgtp58 wgtp59 wgtp60 wgtp61 wgtp62 wgtp63 wgtp64
               wgtp65 wgtp66 wgtp67 wgtp68 wgtp69 wgtp70 wgtp71 wgtp72 wgtp73 wgtp74 wgtp75 wgtp76 wgtp77 wgtp78 wgtp79 wgtp80
  Single unit: missing
     Strata 1: <one>
         SU 1: <observations>
        FPC 1: <zero>

. svyset [pw=wgtp], sdr(wgtp1 - wgtp80) vce(sdr) mse

      pweight: wgtp
          VCE: sdr
          MSE: on
    sdrweight: wgtp1 wgtp2 wgtp3 wgtp4 wgtp5 wgtp6 wgtp7 wgtp8 wgtp9 wgtp10 wgtp11 wgtp12 wgtp13 wgtp14 wgtp15 wgtp16 wgtp17 wgtp18 wgtp19 wgtp20 wgtp21 wgtp22
               wgtp23 wgtp24 wgtp25 wgtp26 wgtp27 wgtp28 wgtp29 wgtp30 wgtp31 wgtp32 wgtp33 wgtp34 wgtp35 wgtp36 wgtp37 wgtp38 wgtp39 wgtp40 wgtp41 wgtp42 wgtp43
               wgtp44 wgtp45 wgtp46 wgtp47 wgtp48 wgtp49 wgtp50 wgtp51 wgtp52 wgtp53 wgtp54 wgtp55 wgtp56 wgtp57 wgtp58 wgtp59 wgtp60 wgtp61 wgtp62 wgtp63 wgtp64
               wgtp65 wgtp66 wgtp67 wgtp68 wgtp69 wgtp70 wgtp71 wgtp72 wgtp73 wgtp74 wgtp75 wgtp76 wgtp77 wgtp78 wgtp79 wgtp80
  Single unit: missing
     Strata 1: <one>
         SU 1: <observations>
        FPC 1: <zero>

. svy: mean fincp
(running mean on estimation sample)

SDR replications (80)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..............................

Survey: Mean estimation           Number of obs   =    102,982
                                  Population size =  1,685,364
                                  Replications    =         80

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
       fincp |    77870.8   252.8541      77375.22    78366.39
--------------------------------------------------------------

. svy: mean valp
(running mean on estimation sample)

SDR replications (80)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..............................

Survey: Mean estimation           Number of obs   =    111,087
                                  Population size =  1,720,596
                                  Replications    =         80

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
        valp |   196479.5   821.9307      194868.5    198090.5
--------------------------------------------------------------

. svy: mean np
(running mean on estimation sample)

SDR replications (80)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..............................

Survey: Mean estimation           Number of obs   =    158,764
                                  Population size =  2,903,199
                                  Replications    =         80

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          np |   2.117291    .004835      2.107814    2.126767
--------------------------------------------------------------

.  svy: mean st
(running mean on estimation sample)

SDR replications (80)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..................................................    50
..............................

Survey: Mean estimation           Number of obs   =    158,764
                                  Population size =  2,903,199
                                  Replications    =         80

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          st |         47          .             .           .
--------------------------------------------------------------

. svyset [pw=wgtp], sdr(wgtp1 - wgtp15) vce(sdr) mse

      pweight: wgtp
          VCE: sdr
          MSE: on
    sdrweight: wgtp1 wgtp2 wgtp3 wgtp4 wgtp5 wgtp6 wgtp7 wgtp8 wgtp9 wgtp10 wgtp11 wgtp12 wgtp13 wgtp14 wgtp15
  Single unit: missing
     Strata 1: <one>
         SU 1: <observations>
        FPC 1: <zero>

. svy: mean st
(running mean on estimation sample)

SDR replications (15)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
...............

Survey: Mean estimation           Number of obs   =    158,764
                                  Population size =  2,903,199
                                  Replications    =         15

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          st |         47          .             .           .
--------------------------------------------------------------

. sort np

. sort type

. mean np

Mean estimation                   Number of obs   =    158,764

--------------------------------------------------------------
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          np |   2.069632   .0035396      2.062694    2.076569
--------------------------------------------------------------

. svy: sum np
summarize is not supported by svy with vce(sdr); see help svy estimation for a list of Stata estimation commands that are supported by svy
r(322);

. sum np

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
          np |    158,764    2.069632    1.410354          0         20

. drop in 144814/158764
(13,951 observations deleted)

. svy: mean np
(running mean on estimation sample)

SDR replications (15)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
...............

Survey: Mean estimation           Number of obs   =    144,813
                                  Population size =  2,903,199
                                  Replications    =         15

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          np |   2.117291    .004851      2.107783    2.126798
--------------------------------------------------------------

. clear

. import delimited "C:\Users\SITGuest\Desktop\psam_h47 (10).csv"
(233 vars, 158764 obs)

. svyset [pw=wgtp], sdr(wgtp16 - wgtp17) vce(sdr) mse

      pweight: wgtp
          VCE: sdr
          MSE: on
    sdrweight: wgtp16 wgtp17
  Single unit: missing
     Strata 1: <one>
         SU 1: <observations>
        FPC 1: <zero>

. svy: mean np
(running mean on estimation sample)

SDR replications (2)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..

Survey: Mean estimation           Number of obs   =    158,764
                                  Population size =  2,903,199
                                  Replications    =          2

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          np |   2.117291   .0065269      2.104498    2.130083
--------------------------------------------------------------

. sum np

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
          np |    158,764    2.069632    1.410354          0         20

. drop if np>3
(24,755 observations deleted)

. drop if np<3
(113,495 observations deleted)

. sum np

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
          np |     20,514           3           0          3          3

.  svy: mean np
(running mean on estimation sample)

SDR replications (2)
----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5 
..

Survey: Mean estimation           Number of obs   =     20,514
                                  Population size =    408,545
                                  Replications    =          2

--------------------------------------------------------------
             |                SDR *
             |       Mean   Std. Err.     [95% Conf. Interval]
-------------+------------------------------------------------
          np |          3          .             .           .
--------------------------------------------------------------

