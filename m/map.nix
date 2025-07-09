{
  # In physical order from top to bottom (see note below)
  ssf = {
    # Switches for Ethernet and OmniPath
    switch-C6-S1A-05 = { pos=42; size=1; model="Dell S3048-ON"; };
    switch-opa = { pos=41; size=1; };

    # SSF login
    apex = { pos=39; size=2; label="SSFHEAD"; board="R2208WTTYSR"; contact="rodrigo.arias@bsc.es"; };

    # Storage
    bay   = { pos=38; size=1; label="MDS01"; board="S2600WT2R"; sn="BQWL64850303"; contact="rodrigo.arias@bsc.es"; };
    lake1 = { pos=37; size=1; label="OSS01"; board="S2600WT2R"; sn="BQWL64850234"; contact="rodrigo.arias@bsc.es"; };
    lake2 = { pos=36; size=1; label="OSS02"; board="S2600WT2R"; sn="BQWL64850266"; contact="rodrigo.arias@bsc.es"; };

    # Compute xeon
    owl1   = { pos=35; size=1; label="SSF-XEON01"; board="S2600WTTR"; sn="BQWL64954172"; contact="rodrigo.arias@bsc.es"; };
    owl2   = { pos=34; size=1; label="SSF-XEON02"; board="S2600WTTR"; sn="BQWL64756560"; contact="rodrigo.arias@bsc.es"; };
    xeon03 = { pos=33; size=1; label="SSF-XEON03"; board="S2600WTTR"; sn="BQWL64750826"; contact="rodrigo.arias@bsc.es"; };
    # Slot 34 empty
    koro   = { pos=31; size=1; label="SSF-XEON05"; board="S2600WTTR"; sn="BQWL64954293"; contact="rodrigo.arias@bsc.es"; };
    xeon06 = { pos=30; size=1; label="SSF-XEON06"; board="S2600WTTR"; sn="BQWL64750846"; contact="antoni.navarro@bsc.es"; };
    hut    = { pos=29; size=1; label="SSF-XEON07"; board="S2600WTTR"; sn="BQWL64751184"; contact="rodrigo.arias@bsc.es"; };
    eudy   = { pos=28; size=1; label="SSF-XEON08"; board="S2600WTTR"; sn="BQWL64756586"; contact="aleix.rocanonell@bsc.es"; };

    # 16 KNL nodes, 4 per chassis
    knl01_04 = { pos=26; size=2; label="KNL01..KNL04"; board="HNS7200APX"; };
    knl05_08 = { pos=24; size=2; label="KNL05..KNL18"; board="HNS7200APX"; };
    knl09_12 = { pos=22; size=2; label="KNL09..KNL12"; board="HNS7200APX"; };
    knl13_16 = { pos=20; size=2; label="KNL13..KNL16"; board="HNS7200APX"; };

    # Slot 19 empty

    # EPI (hw team, guessed order)
    epi01 = { pos=18; size=1; contact="joan.cabre@bsc.es"; };
    epi02 = { pos=17; size=1; contact="joan.cabre@bsc.es"; };
    epi03 = { pos=16; size=1; contact="joan.cabre@bsc.es"; };
    anon  = { pos=14; size=2; }; # Unlabeled machine. Operative

    # These are old and decommissioned (off)
    power8    = { pos=12; size=2; label="BSCPOWER8N3";   decommissioned=true; };
    powern1   = { pos=8;  size=4; label="BSCPOWERN1";    decommissioned=true; };
    gustafson = { pos=7;  size=1; label="gustafson";     decommissioned=true; };
    odap01    = { pos=3;  size=4; label="ODAP01";        decommissioned=true; };
    amhdal    = { pos=2;  size=1; label="AMHDAL";        decommissioned=true; }; # sic
    moore     = { pos=1;  size=1; label="moore (earth)"; decommissioned=true; };
  };

  bsc2218 = {
    raccoon = { board="W2600CR"; sn="QSIP22500829"; contact="rodrigo.arias@bsc.es"; };
    tent    = { label="SSF-XEON04"; board="S2600WTTR"; sn="BQWL64751229"; contact="rodrigo.arias@bsc.es"; };
  };

  upc = {
    fox = { board="H13DSG-O-CPU"; sn="UM24CS600392"; prod="AS-4125GS-TNRT"; prod_sn="E508839X5103339"; contact="rodrigo.arias@bsc.es"; };
  };

  # NOTE: Position is specified in "U" units (44.45 mm) and starts at 1 from the
  # bottom. Example:
  #
  #  |   ...  | - [pos+size] <--- Label in chassis
  #  +--------+
  #  |  node  | - [pos+1]
  #  |   2U   | - [pos]
  #  +------- +
  #  |   ...  | - [pos-1]
  #
  # NOTE: The board and sn refers to the FRU information (Board Product and
  # Board Serial) via `ipmitool fru print 0`.
}
