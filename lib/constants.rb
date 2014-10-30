module S2Eco
  # Total number of days to simulate
  DAYS_TOTAL   = 100
  # DAYS_TOTAL   = 360
  # DAYS_TOTAL = 1080

  # P_FEAT_CM = Probability that a context model cell is filled
  P_FEAT_CM_MAX = 100
  P_FEAT_CM_MIN = 1
  P_FEAT_S      = 0.04

  P_PREF_USER   = 0.45

  # NUM_CM = Number of CM possibly associated with a CM of X features
  NUM_CM_MAX = 70
  NUM_CM_MIN = 1
  
  DEV_MIN, DEV_MAX = [1, 180]
  P_INACTIVE = 0.0027

  POP_MAX_DEV = 120_000
  POP_MIN_DEV = 1_000
  S_DEV       = -0.005
  D_DEV       = -4.0

  POP_MAX_USER = 400_000
  POP_MIN_USER = 1_500
  S_USER       = -0.0038
  D_USER       = -4.0

  BRO_MIN, BRO_MAX = [1, 360]
end