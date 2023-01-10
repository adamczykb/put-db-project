import { Form, Input } from "antd";

export const getCookie = () => {
  let cookieValue = null;

  if (document.cookie && document.cookie !== "") {
    const cookies = document.cookie.split(";");
    for (let i = 0; i < cookies.length; i++) {
      const cookie = cookies[i].trim();

      // Does this cookie string begin with the name we want?
      // eslint-disable-next-line
      if (cookie.substring(0, "csrftoken".length + 1) === "csrftoken" + "=") {
        cookieValue = decodeURIComponent(
          cookie.substring("csrftoken".length + 1)
        );

        break;
      }
    }
  }

  return String(cookieValue);
};

const CSRFTOKEN = () => {
  return (
    <Form.Item name="csrfmiddlewaretoken" style={{ display: "none" }}>
      <Input type="hidden" value={getCookie()} />
    </Form.Item>
  );
};

export default CSRFTOKEN;

