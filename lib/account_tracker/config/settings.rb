# module AccountTracker
#   class Config
#     include Singleton
#     
#     def self.settings
#       instance.settings
#     end
#     
#     def settings
#       @settings || default_settings
#     end
#     
#     private
#     
#     def default_settings
#       {
#         url: "https://api.sandbox.ewaypayments.com",
#         username: "payments@mobcash.com.au",
#         password: "A1001Crnr10CfgfwQyzSS0wwT9Jpc5wd22uymdxR7sQzIjZfkaXfpdhOecN2Z5ah7YUAyV"
#       }
#     end
#   end
# end