function deleteComment(commentId) {
    fetch("/delete-comment", {
      method: "POST",
      body: JSON.stringify({ commentId: commentId }),
    }).then((_res) => {
      window.location.href = "/";
    });
  }