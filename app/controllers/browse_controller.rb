class BrowseController < ApplicationController
    def browse
        liked_account_ids = Like.where(account_id: current_account.id).map(&:liked_account_id)
        liked_account_ids << current_account.id
        @dogs = Account.where.not(id: liked_account_ids)
        @matches = current_account.matches
    end

    def approve
        account_id = params[:id]
        logger.debug "User id is matching #{account_id}"

        new_like = Like.new(liked_account_id: account_id)
        new_like.account_id = current_account.id

        if new_like.save
            Like.where(account_id: account_id, liked_account_id: current_account.id)
            @they_like_us = existing_like > 0
        else

        end
    end

    def decline
    end

    def open_conversation
        @profile = Account.find(params[:id])
        likes = Like.where(account_id: current_account.id, liked_account_id: params[:id])
        @match = likes.first if likes.size > 0

        conversation = Conversation.between(params[:id], current_account.id)

        @conversation = conversation.size > 0 ? conversation.first : Conversation.new
        @message = @conversation.messages.build

        if @profile.present?
            respond_to do |format|
                format.js {
                    render "browse/conversation"
                }
            end
        end
    end
end
