export type GrafanaConfig = {
  logs: {
    loki: {
      host: string;
      user: string;
      apiKey: string;
    };
  };
};
