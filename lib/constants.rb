module S2Eco
  # Total number of days to simulate
  DAYS_TOTAL = 100

  # P_FEAT_CM = Probability that a context model cell is filled
  P_FEAT_CM_MAX = 100
  P_FEAT_CM_MIN = 1

  # NUM_CM = Number of CM possibly associated with a CM of X features
  NUM_CM_MAX = 70
  NUM_CM_MIN = 1
  
  DEV_MIN, DEV_MAX = [1, 180]

  POP_MAX_DEV = 120_000
  POP_MIN_DEV = 1_000
  S_DEV       = -0.005
  D_DEV       = -4.0
end