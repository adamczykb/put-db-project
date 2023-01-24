import { ReactElement } from "react";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Home from "../components/home/Home";
import Employee from "../components/Employee/Employee";
import Travel from "../components/Travels/Travel";
import TravelForm from "../components/Travels/Travel_Form";
import PilotsView from "../components/Pilots/Pilots";
import AddPilot from "../components/Pilots/AddPilot";
import UpdatePilot from "../components/Pilots/UpdatePilot";
import AccomodationView from "../components/Accomodation/Accomodation";
import AddClients from "../components/home/AddClient";
import UpdateClient from "../components/home/UpdateClient";
import AddAccommodanion from "../components/Accomodation/AddAccomodation";
import TransportCompanyView from "../components/TransportCompany/TransportCompany";
import AddEmployee from "../components/Employee/AddEmployee";
import TransportyView from "../components/TransportCompany/Transport";
import AddTransportCompany from "../components/TransportCompany/AddTransportCompany";
import AddTransport from "../components/TransportCompany/AddTransport";
import AttractionView from "../components/Attraction/Attraction";
import EtapView from "../components/Etap/Etap";
import JourneysView from "../components/Journey/Journey";
import AddEtap from "../components/Etap/AddEtap";



const IndexRouter: React.FC = (): ReactElement => {
    return (
        <BrowserRouter>
            <Routes>
                <Route path={"/"} element={<Travel />} />
                <Route path={"/klienty"} element={<Home />} />
                <Route path={"/klienty/dodaj"} element={<AddClients />} />
                <Route path={"/klienty/edycja/:pesel"} element={<UpdateClient />} />
                <Route path={"/pracownicy"} element={<Employee />} />
                <Route path={"/pracownicy/dodaj"} element={<AddEmployee />} />
                <Route path={"/podrozy/dodaniePodrozy"} element={<TravelForm />} />
                <Route path={"/przewodnicy"} element={<PilotsView />} />
                <Route path={"/przewodnicy/dodaj"} element={<AddPilot />} />
                <Route path={"/przewodnicy/edycja/:id"} element={<UpdatePilot />} />
                <Route path={"/zakwaterowanie"} element={<AccomodationView />} />
                <Route path={"/zakwaterowanie/dodaj"} element={<AddAccommodanion />} />
                <Route path={"/zakwaterowanie/dodaj"} element={<AddAccommodanion />} />
                <Route path={"/firma_transportowa"} element={<TransportCompanyView/>}/>
                <Route path={"/firma_transportowa/dodaj"} element={<AddTransportCompany/>}/>
                <Route path={"/transporty"} element={<TransportyView/>}/>
                <Route path={"/transporty/dodaj"} element={<AddTransport/>}/>
                <Route path={"/atrakcje"} element={<AttractionView/>}/>
                <Route path={"/etapy"} element={<EtapView/>}/>
                <Route path={"/etapy/dodaj"} element={<AddEtap/>}/>
                <Route path={"/podrozy"} element={<JourneysView/>}/>
                
            </Routes>
        </BrowserRouter>
    );
};
export default IndexRouter;
