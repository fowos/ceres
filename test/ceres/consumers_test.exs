# defmodule Ceres.ConsumersTest do
#   use Ceres.DataCase

#   alias Ceres.Consumers

#   describe "consumers" do
#     alias Ceres.Consumers.Consumer

#     import Ceres.AccountsFixtures, only: [user_scope_fixture: 0]
#     import Ceres.ConsumersFixtures

#     @invalid_attrs %{name: nil, public_key: nil}

#     test "list_consumers/1 returns all scoped consumers" do
#       scope = user_scope_fixture()
#       other_scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       other_consumer = consumer_fixture(other_scope)
#       assert Consumers.list_consumers(scope) == [consumer]
#       assert Consumers.list_consumers(other_scope) == [other_consumer]
#     end

#     test "get_consumer!/2 returns the consumer with given id" do
#       scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       other_scope = user_scope_fixture()
#       assert Consumers.get_consumer!(scope, consumer.id) == consumer
#       assert_raise Ecto.NoResultsError, fn -> Consumers.get_consumer!(other_scope, consumer.id) end
#     end

#     test "create_consumer/2 with valid data creates a consumer" do
#       valid_attrs = %{name: "some name", public_key: "some public_key"}
#       scope = user_scope_fixture()

#       assert {:ok, %Consumer{} = consumer} = Consumers.create_consumer(scope, valid_attrs)
#       assert consumer.name == "some name"
#       assert consumer.public_key == "some public_key"
#     end

#     test "create_consumer/2 with invalid data returns error changeset" do
#       scope = user_scope_fixture()
#       assert {:error, %Ecto.Changeset{}} = Consumers.create_consumer(scope, @invalid_attrs)
#     end

#     test "update_consumer/3 with valid data updates the consumer" do
#       scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       update_attrs = %{name: "some updated name", public_key: "some updated public_key"}

#       assert {:ok, %Consumer{} = consumer} = Consumers.update_consumer(scope, consumer, update_attrs)
#       assert consumer.name == "some updated name"
#       assert consumer.public_key == "some updated public_key"
#     end

#     test "update_consumer/3 with invalid scope raises" do
#       scope = user_scope_fixture()
#       other_scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)

#       assert_raise MatchError, fn ->
#         Consumers.update_consumer(other_scope, consumer, %{})
#       end
#     end

#     test "update_consumer/3 with invalid data returns error changeset" do
#       scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       assert {:error, %Ecto.Changeset{}} = Consumers.update_consumer(scope, consumer, @invalid_attrs)
#       assert consumer == Consumers.get_consumer!(scope, consumer.id)
#     end

#     test "delete_consumer/2 deletes the consumer" do
#       scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       assert {:ok, %Consumer{}} = Consumers.delete_consumer(scope, consumer)
#       assert_raise Ecto.NoResultsError, fn -> Consumers.get_consumer!(scope, consumer.id) end
#     end

#     test "delete_consumer/2 with invalid scope raises" do
#       scope = user_scope_fixture()
#       other_scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       assert_raise MatchError, fn -> Consumers.delete_consumer(other_scope, consumer) end
#     end

#     test "change_consumer/2 returns a consumer changeset" do
#       scope = user_scope_fixture()
#       consumer = consumer_fixture(scope)
#       assert %Ecto.Changeset{} = Consumers.change_consumer(scope, consumer)
#     end
#   end

#   describe "comments" do
#     alias Ceres.Consumers.Comment

#     import Ceres.ConsumersFixtures

#     @invalid_attrs %{text: nil}

#     test "list_comments/0 returns all comments" do
#       comment = comment_fixture()
#       assert Consumers.list_comments() == [comment]
#     end

#     test "get_comment!/1 returns the comment with given id" do
#       comment = comment_fixture()
#       assert Consumers.get_comment!(comment.id) == comment
#     end

#     test "create_comment/1 with valid data creates a comment" do
#       valid_attrs = %{text: "some text"}

#       assert {:ok, %Comment{} = comment} = Consumers.create_comment(valid_attrs)
#       assert comment.text == "some text"
#     end

#     test "create_comment/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = Consumers.create_comment(@invalid_attrs)
#     end

#     test "update_comment/2 with valid data updates the comment" do
#       comment = comment_fixture()
#       update_attrs = %{text: "some updated text"}

#       assert {:ok, %Comment{} = comment} = Consumers.update_comment(comment, update_attrs)
#       assert comment.text == "some updated text"
#     end

#     test "update_comment/2 with invalid data returns error changeset" do
#       comment = comment_fixture()
#       assert {:error, %Ecto.Changeset{}} = Consumers.update_comment(comment, @invalid_attrs)
#       assert comment == Consumers.get_comment!(comment.id)
#     end

#     test "delete_comment/1 deletes the comment" do
#       comment = comment_fixture()
#       assert {:ok, %Comment{}} = Consumers.delete_comment(comment)
#       assert_raise Ecto.NoResultsError, fn -> Consumers.get_comment!(comment.id) end
#     end

#     test "change_comment/1 returns a comment changeset" do
#       comment = comment_fixture()
#       assert %Ecto.Changeset{} = Consumers.change_comment(comment)
#     end
#   end
# end
