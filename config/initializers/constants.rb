module GlobalConst
  # TRACKING_BRANCHES = ['master']
  WAIT_TIME_BETWEEN_MERGE_ENQUEUE_TRY = 30.seconds
  UNLOCKED_BRANCHES = ['master', '015_release']
  ALLOWED_MERGES_AGAINST = UNLOCKED_BRANCHES
  VALID_TARGET_BRANCHES_REGEXP = /\A(master|\d{3}_release|\d{3}_\d+_\d+_release|\d{3}_\d+_release)\z/
end
