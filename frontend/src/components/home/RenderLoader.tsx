import { Spin } from "antd";

export const RenderLoader = () => {
    return (
        <div
            style={{ height: "400px", margin: "20px" }}
            className={"horizontal-center"}
        >
            <br />
            <Spin size="large" />
        </div>
    );
};
