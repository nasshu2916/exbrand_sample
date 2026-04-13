defmodule ExbrandSampleWeb.UserPageHTML do
  use ExbrandSampleWeb, :html

  alias ExbrandSample.Accounts.User

  embed_templates "user_page_html/*"

  attr :form, :map, required: true
  attr :action, :string, required: true
  attr :method, :string, default: "post"
  attr :submit_label, :string, required: true

  def user_form(assigns) do
    ~H"""
    <.form for={@form} id="user-form" action={@action} method={@method}>
      <div class="grid gap-5 sm:grid-cols-2">
        <div>
          <.input
            field={@form[:user_id]}
            type="number"
            label="User ID"
            class="w-full rounded-[18px] border border-zinc-300 bg-stone-50 px-4 py-3 text-zinc-950"
            error_class="border-rose-400 bg-rose-50"
            min="1"
            required
          />
        </div>

        <div>
          <.input
            field={@form[:status]}
            type="select"
            label="Status"
            options={status_options()}
            class="w-full rounded-[18px] border border-zinc-300 bg-stone-50 px-4 py-3 text-zinc-950"
            error_class="border-rose-400 bg-rose-50"
          />
        </div>

        <div class="sm:col-span-2">
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            class="w-full rounded-[18px] border border-zinc-300 bg-stone-50 px-4 py-3 text-zinc-950"
            error_class="border-rose-400 bg-rose-50"
            required
          />
        </div>

        <div class="sm:col-span-2">
          <.input
            field={@form[:nickname]}
            type="text"
            label="Nickname"
            class="w-full rounded-[18px] border border-zinc-300 bg-stone-50 px-4 py-3 text-zinc-950"
            error_class="border-rose-400 bg-rose-50"
            minlength="3"
            required
          />
        </div>
      </div>

      <div class="mt-8 flex flex-wrap items-center justify-between gap-4 border-t border-zinc-200 pt-6">
        <p class="text-sm leading-7 text-zinc-500">入力値は brand validation を通して保存されます。</p>
        <button
          type="submit"
          class="inline-flex items-center justify-center rounded-full bg-zinc-950 px-5 py-3 text-sm font-semibold text-white transition hover:bg-zinc-800"
        >
          {@submit_label}
        </button>
      </div>
    </.form>
    """
  end

  attr :status, :atom, required: true

  def status_badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex rounded-full px-3 py-1 text-xs font-semibold",
      if(@status == :active,
        do: "bg-emerald-100 text-emerald-700",
        else: "bg-amber-100 text-amber-700"
      )
    ]}>
      {@status}
    </span>
    """
  end

  def user_id(%User{} = user), do: user.user_id
  def email(%User{} = user), do: user.email
  def nickname(%User{} = user), do: user.nickname
  def status_options, do: [{"Invited", "invited"}, {"Active", "active"}]
end
