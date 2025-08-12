require "hirb"

namespace :app do
  task routes: :environment do
    routes = Rails.application.routes.routes.map do |r|
      {
        verb: r.verb,
        path: r.path.spec.to_s,
        controller: r.defaults[:controller],
        action: r.defaults[:action],
        format: r.defaults[:format],
        name: r.name,
        subdomain: r.constraints[:subdomain] || ""
      }
    end

    # routes = routes.filter { |r| !r[:path].include?("/rails") && !(r[:controller] || '').include?("turbo") }

    puts Hirb::Helpers::Table.render(routes, { fields: [ :subdomain, :verb, :path, :controller, :action, :format, :name ] })
  end
end
