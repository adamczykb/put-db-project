import { createContext, useContext, useState } from "react";
import { useMediaQuery } from "react-responsive";

const AppContext = createContext({
  viewSettings: { isDesktop: false, isCompressedViewNeeded: false },
});

// Hook to provide access to context object
export const UseAppContext = () => {
  return useContext(AppContext);
};

export const AppContextProvider = (props: AppContextProviderArguments) => {
  const isDesktop = useMediaQuery({ query: "(min-width: 1500px)" });
  const isCompressedViewNeeded = useMediaQuery({ query: "(min-width: 900px)" });

  // Assign React state and constants to context object
  const AppContextObject = {
    viewSettings: {
      isDesktop,
      isCompressedViewNeeded,
    },
  };
  return (
    <AppContext.Provider value={AppContextObject}>
      {props.children}
    </AppContext.Provider>
  );
};

interface AppContextProviderArguments {
  children: JSX.Element;
}
