import { Switch } from "antd";
import { ReactElement } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "../components/home/Home";
import Employee from "../components/Employee/Employee";
import Travel from "../components/Travels/Travel";
import TravelForm from "../components/Travels/Travel_Form";
import ClientForm from "../components/home/Client_Form";

//import React from "react-router-dom";

const IndexRouter: React.FC = (): ReactElement => {
  return (
    <BrowserRouter>
      <Routes>
        <Route path={"/klienty/dodac_klienta"} element={<ClientForm />} />
        <Route path={"/klienty"} element={<Home />} />
        <Route path={"/pracowniki"} element={<Employee />} />
        <Route path={"/podrozy"} element={<Travel />}/>
        <Route path={"/podrozy/dodaniePodrozy"} element={<TravelForm />} />
        </Routes>
    </BrowserRouter>
  );
};
export default IndexRouter;
