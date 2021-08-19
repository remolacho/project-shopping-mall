class PdfController < ActionController::Base

  def invoice
    @order = Order.find(params[:id])
    respond_to do |format|
      format.pdf do
        render pdf: "file_name",
        margin:  { top: 20 },
        show_as_html: params.key?('debug'),
        footer: {content: render_to_string({template: 'layouts/footer.pdf.erb'})},
        encoding: 'utf8'
      end
    end
  end

end