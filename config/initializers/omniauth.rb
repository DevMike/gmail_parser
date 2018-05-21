Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "787053238456-820tq02bqe5m29ibibptr6qeraqjdah7.apps.googleusercontent.com", "VX64dmMj8iqkIN3FsF6DJI6F", {
    provider_ignores_state: true,
    scope: ['https://mail.google.com/', 'email'],
    redirect_uri: 'http://localhost:3000/auth/google_oauth2/callback'
  }
end
