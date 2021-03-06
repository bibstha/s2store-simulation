module S2Eco
  # Total number of days to simulate
  # DAYS_TOTAL   = 3
  # DAYS_TOTAL   = 10
  # DAYS_TOTAL   = 40
  DAYS_TOTAL   = 550
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

  DEV_MIN, DEV_MAX = [1, 90]
  P_INACTIVE = 0.0027

  POP_MAX_DEV = 20_000
  POP_MIN_DEV = 100
  S_DEV       = -0.005
  D_DEV       = -4.0

  # POP_MAX_USER = 400_000
  POP_MAX_USER = 80_000
  POP_MIN_USER = 1_500
  S_USER       = -0.0038
  D_USER       = -4.0

  BROWSE_RANGE = 1..360

  KEY_WRD_MAX  = 200

  U_AVOID_SIZE = 3

  # MALICIOUS_SIDE = 0..3
  BUGGY_SIDE     = 6..9

  P_VOTER        = 0.2
  P_APPS_TO_VOTE = 0.5

  TOP_NEW_SERVICES  = 50
  TOP_BEST_SERVICES = 50
end
