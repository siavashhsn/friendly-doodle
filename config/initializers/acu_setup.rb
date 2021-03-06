Acu.setup do |config|
  # to tighten the security this is enabled by default
  # i.e if it checked to be true, then if a request didn't match to any of rules, it will get passed through
  # otherwise the requests which don't fit into any of rules, the request is denied by default
  config.allow_by_default = false

  # the audit log file, to log how the requests handles, good for production
  # leave it black for nil to disable the logging
  config.audit_log_file   = Rails.root.join("tmp", "acu-auth.log")

  # cache the rules to make rule matching much faster
  # it's not recommended to use it in developement/test evn.
  config.use_cache = false

  # the caching namespace
  config.cache_namespace = 'acu'

  # define the expiration of cached entries
  config.cache_expires_in = nil

  # the race condition ttl
  config.cache_race_condition_ttl = nil

  # more details about cache options:
  # http://guides.rubyonrails.org/caching_with_rails.html
end