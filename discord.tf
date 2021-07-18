resource "discord_server" "openvac" {
  name     = "OpenVac"
  owner_id = "85950745328771072"
  region   = "singapore"
}

resource "discord_text_channel" "welcome" {
  name      = "welcome"
  server_id = discord_server.openvac.id
}

resource "discord_invite" "public-invite" {
  channel_id = discord_text_channel.welcome.id
  max_age    = 0
}

output "discord_invite_code" {
  value     = discord_invite.public-invite.code
  sensitive = false
}
