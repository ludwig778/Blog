module ApplicationHelper
    def gravatar_for(user, options = { size: 80, design: "img-thumbnail"})
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.username, class: options[:design])
    end

    def title(page_title)
        content_for :title, page_title.to_s
    end

    def current_gravatar(options = { size: 80, design: "img-thumbnail"})
      current_user ||= User.find_by(id: session[:user_id])
      gravatar_for(current_user, options)
    end
end
