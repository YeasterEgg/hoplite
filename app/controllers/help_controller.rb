class HelpController < ApplicationController
  before_action :get_help, only: [:create_help]

  def help
    @helps = Help.all
  end

  def help_to_ajax
    help = Help.find(params[:id])
    if help
      render text: help.render_text
    else
      redirect_to :back
    end
  end

  def new_help
    @help = Help.new
  end

  def create_help
    @help = Help.new(get_help)
    @help.save
    redirect_to new_help_path
  end

  def delete_help
    @help = Help.find(params[:id])
    if @help
      @help.destroy
    end
    render inline: "location.reload();"
  end

  private

    def get_help
      params.require(:help).permit([:title,:text])
    end

end
