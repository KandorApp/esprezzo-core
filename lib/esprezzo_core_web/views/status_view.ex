defmodule EsprezzoCoreWeb.StatusView do
  use EsprezzoCoreWeb, :view

  def render("index.json", status) do
    %{:status => status}
  end

  # def render("index.json", %{posts: posts}) do
  #   %{data: render_many(posts, Neuropa.PostView, "post.json")}
  # end

  # def render("show.json", %{post: post}) do
  #   %{data: render_one(post, Neuropa.PostView, "post.json")}
  # end

  # def render("post.json", %{post: post}) do
  #   %{id: post.id,
  #     title: post.title,
  #     body: post.body,
  #     profile_id: post.profile_id,
  #     client_scope: post.client_scope}
  # end

end
