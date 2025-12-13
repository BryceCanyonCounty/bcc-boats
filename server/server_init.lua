Core = exports.vorp_core:GetCore()
BccUtils = exports['bcc-utils'].initiate()
Discord = BccUtils.Discord.setup(Config.Webhook, Config.WebhookTitle, Config.webhookAvatar)
DBG = BccUtils.Debug:Get('bcc-boats', Config.devMode.active)

if DBG and Config.devMode.active then
    DBG:Enable()
end
DBG:Info('Boats debug initialized')
