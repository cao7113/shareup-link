require Protocol

Protocol.derive(Jason.Encoder, Flop.Meta,
  only: [
    :current_page,
    :has_next_page?,
    :has_previous_page?,
    :next_page,
    :page_size,
    :previous_page,
    :total_pages
  ]
)
