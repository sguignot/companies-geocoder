class Proxy < ActiveRecord::Base
  class OverQueryLimitError < Exception; end

  def self.with_proxy_lock
    proxy = Proxy.where('daily_quota_hit_at IS NULL OR daily_quota_hit_at <= ?', Time.now.utc - 1.day).where(last_query_at: nil).first
    proxy ||= Proxy.where('daily_quota_hit_at IS NULL OR daily_quota_hit_at <= ?', Time.now.utc - 1.day).order(:last_query_at).first
    begin
      proxy.with_lock do
        yield(proxy)
        proxy.update_attributes!(last_query_at: Time.now.utc)
      end
    rescue OverQueryLimitError => e
      proxy.update_attributes!(daily_quota_hit_at: Time.now.utc)
      raise e
    end
  end
end
