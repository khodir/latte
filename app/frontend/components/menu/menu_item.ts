export type MenuItem = {
  items?: MenuItem[] | undefined;
  label: string;
  icon: string;
  link?: string | undefined;
  method?: string | undefined;
  expanded?: boolean | false;
}