import { Switch } from "antd";
import { ReactElement } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "../components/home/Home";
import Employee from "../components/Employee/Employee";
//import React from "react-router-dom";

const IndexRouter: React.FC = (): ReactElement => {
  return (
    <BrowserRouter>
      <Routes>
        
        <Route path={"/klienty"} element={<Home />} />
        <Route path={"/pracowniki"} element={<Employee />} />
        </Routes>
    </BrowserRouter>
  );
};
export default IndexRouter;
