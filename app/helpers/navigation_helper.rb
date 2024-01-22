module NavigationHelper
    def ensure_navigation
        @navigation ||= [ { :title => 'Home', :url => '/' } ]
    end

    def navigation_add(title, url)
        ensure_navigation << { :title => title, :url => url }
    end

    def render_navigation
        render partial: "shared/navigation", locals: { nav: ensure_navigation }
    end

    def navbar_items
        [
            { content: t("header.navbar.find_gigs"), path: gigs_path }
        ]
    end

    def navbar_with_search_items
        [
            { content: t("header.navbar.order"), path: "#" }
        ]
    end

    def seller_navbar_items
        [
            { content: t("header.navbar.manage_gigs"), path: manage_gigs_gigs_path },
            { content: t("header.navbar.manage_orders"), path: manage_orders_gig_clients_path },
            { content: t("header.navbar.my_earnings"), path: "#" }
        ]
    end
end
