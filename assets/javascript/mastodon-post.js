/*
 * From `mastodon-post` by David Darnes
 * https://github.com/daviddarnes/mastodon-post
 *
 * Customised: the post URL can come from a fallback
 * `<blockquote cite="...">` child, which is displayed when JS is disabled or
 * the API fetch fails, and replaced with the fetched post otherwise.
 */

const mastodonPostTemplate = document.createElement("template");

mastodonPostTemplate.innerHTML = `
<figure>
  <figcaption>
    <img class="avatar" data-key="account.avatar" alt="" />
    <cite>
      <a class="author-name" data-key="account.url"><span data-key="account.display_name"></span></a>
      <a class="author-handle" data-key="account.url"><span data-key="username"></span>@<span data-key="hostname"></span></a>
    </cite>
  </figcaption>
  <blockquote data-key="content"></blockquote>
  <footer>
    <dl>
      <dt title="Reposts"><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="17 1 21 5 17 9"></polyline><path d="M3 11V9a4 4 0 0 1 4-4h14"></path><polyline points="7 23 3 19 7 15"></polyline><path d="M21 13v2a4 4 0 0 1-4 4H3"></path></svg><span class="visually-hidden">Reposts</span></dt>
      <dd data-key="reblogs_count"></dd>
      <dt title="Replies"><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path></svg><span class="visually-hidden">Replies</span></dt>
      <dd data-key="replies_count"></dd>
      <dt title="Favourites"><svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg><span class="visually-hidden">Favourites</span></dt>
      <dd data-key="favourites_count"></dd>
    </dl>
    <a class="post-date" data-key="url"><time data-key="created_at"></time></a>
  </footer>
</figure>
`;

mastodonPostTemplate.id = "mastodon-post-template";

if (!document.getElementById(mastodonPostTemplate.id)) {
  document.body.appendChild(mastodonPostTemplate);
}

class MastodonPost extends HTMLElement {
  static register(tagName) {
    if ("customElements" in window) {
      customElements.define(tagName || "mastodon-post", MastodonPost);
    }
  }

  async connectedCallback() {
    const fallback = this.querySelector('blockquote[data-source="fediverse"]');

    let data;
    try {
      data = { ...(await this.data), ...this.linkData };
    } catch (error) {
      // Keep the static fallback if the post can't be fetched
      return;
    }

    this.append(this.template);

    this.slots.forEach((slot) => {
      slot.dataset.key.split(",").forEach((keyItem) => {
        const value = this.getValue(keyItem, data);
        if (keyItem === "content") {
          slot.innerHTML = value;
        } else if (keyItem === "created_at") {
          slot.textContent = new Date(value).toLocaleString("en-GB", {
            dateStyle: "short",
            timeStyle: "short"
          });
          if (slot.localName === "time") slot.dateTime = value;
        } else {
          this.populateSlot(slot, value);
        }
      });
    });

    if (fallback) fallback.remove();
  }

  populateSlot(slot, value) {
    if (typeof value == "string" && value.startsWith("http")) {
      if (slot.localName === "img") slot.src = value;
      if (slot.localName === "a") slot.href = value;
    } else {
      slot.textContent = value;
    }
  }

  handleKey(object, key) {
    const parsedKeyInt = parseFloat(key);

    if (Number.isNaN(parsedKeyInt)) {
      return object[key];
    }

    return object[parsedKeyInt];
  }

  getValue(string, data) {
    let keys = string.trim().split(/\.|\[|\]/g);
    keys = keys.filter((string) => string.length);

    const value = keys.reduce(
      (object, key) => this.handleKey(object, key),
      data
    );
    return value;
  }

  get template() {
    return document
      .getElementById(
        this.getAttribute("template") || `${this.localName}-template`
      )
      .content.cloneNode(true);
  }

  get slots() {
    return this.querySelectorAll("[data-key]");
  }

  get link() {
    const fallback = this.querySelector("blockquote[cite]");
    if (fallback) return fallback.cite;
    return this.querySelector("a").href;
  }

  get linkData() {
    const url = new URL(this.link);
    const paths = url.pathname.split("/").filter((string) => string.length);
    return {
      url: this.link,
      hostname: url.hostname,
      username: paths.find((path) => path.startsWith("@")),
      postId: paths.find((path) => !path.startsWith("@"))
    };
  }

  get endpoint() {
    return `https://${this.linkData.hostname}/api/v1/statuses/${this.linkData.postId}`;
  }

  get data() {
    return fetch(this.endpoint).then((response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.json();
    });
  }
}

MastodonPost.register();
