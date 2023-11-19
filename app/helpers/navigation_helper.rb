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
            { content: t("header.navbar.order"), path: "#" },
            { content: t("header.navbar.influencers"), path: gigs_path },
            { content: t("header.navbar.campaign"), path: "#" }
        ]
    end
    def navbar_with_search_items
        [
            { content: t("header.navbar.order"), path: "#" },
            { content: t("header.navbar.influencers"), path: gigs_path },
            { content: t("header.navbar.campaign"), path: "#" }
        ]
    end
end
